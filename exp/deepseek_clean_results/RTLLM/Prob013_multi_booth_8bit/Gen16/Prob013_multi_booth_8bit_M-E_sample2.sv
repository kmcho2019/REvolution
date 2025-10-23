module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    // State encoding
    localparam INIT  = 2'b00;
    localparam PROCESS = 2'b01;
    localparam DONE  = 2'b10;

    reg [1:0] state;
    reg [15:0] multiplicand;
    reg [8:0] multiplier;  // Extra bit for sign extension
    reg [15:0] partial_products [0:3];
    reg [15:0] sum, carry;
    reg [2:0] cycle_count;
    wire special_case;

    // Special case detection (zero or power of 2)
    assign special_case = (a == 8'b0) || (b == 8'b0) || 
                         ((a == 8'b1) || (b == 8'b1));

    // Booth encoder
    function [15:0] booth_encoder;
        input [8:0] mult;
        input [15:0] mcand;
        input [1:0] sel;
        begin
            case (sel)
                2'b00: booth_encoder = 16'b0;
                2'b01: booth_encoder = mcand;
                2'b10: booth_encoder = ~mcand + 1'b1;  // Two's complement
                2'b11: booth_encoder = {mcand[14:0], 1'b0} - mcand;
            endcase
        end
    endfunction

    // 4:2 compressor for partial product reduction
    function [15:0] compressor;
        input [15:0] pp0, pp1, pp2, pp3;
        reg [15:0] s1, c1, s2, c2;
        begin
            // First level of compression
            s1 = pp0 ^ pp1 ^ pp2;
            c1 = ((pp0 & pp1) | (pp0 & pp2) | (pp1 & pp2)) << 1;
            
            // Second level with carry
            s2 = s1 ^ c1 ^ pp3;
            c2 = ((s1 & c1) | (s1 & pp3) | (c1 & pp3)) << 1;
            
            compressor = s2 + c2;
        end
    endfunction

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= INIT;
            multiplicand <= {{8{a[7]}}, a};
            multiplier <= {b, 1'b0};  // Append 0 for initial Booth pair
            p <= 16'b0;
            rdy <= 1'b0;
            cycle_count <= 3'b0;
        end else begin
            case (state)
                INIT: begin
                    if (special_case) begin
                        p <= (a == 8'b1) ? {{8{b[7]}}, b} : 
                            (b == 8'b1) ? {{8{a[7]}}, a} : 16'b0;
                        state <= DONE;
                    end else begin
                        // Generate all partial products in parallel
                        partial_products[0] <= booth_encoder(multiplier[2:0], multiplicand, multiplier[1:0]);
                        partial_products[1] <= booth_encoder(multiplier[4:2], multiplicand << 2, multiplier[3:2]);
                        partial_products[2] <= booth_encoder(multiplier[6:4], multiplicand << 4, multiplier[5:4]);
                        partial_products[3] <= booth_encoder({multiplier[8:6], 1'b0}, multiplicand << 6, multiplier[7:6]);
                        state <= PROCESS;
                        cycle_count <= 3'b001;
                    end
                end

                PROCESS: begin
                    if (cycle_count == 3'b001) begin
                        // First reduction stage
                        {sum, carry} <= {partial_products[0] + partial_products[1], 
                                       partial_products[2] + partial_products[3]};
                        cycle_count <= 3'b010;
                    end else if (cycle_count == 3'b010) begin
                        // Second reduction stage
                        sum <= sum + carry;
                        cycle_count <= 3'b011;
                    end else begin
                        // Final addition
                        p <= sum;
                        state <= DONE;
                    end
                end

                DONE: begin
                    rdy <= 1'b1;
                    state <= INIT;  // Ready for next multiplication
                end
            endcase
        end
    end

endmodule