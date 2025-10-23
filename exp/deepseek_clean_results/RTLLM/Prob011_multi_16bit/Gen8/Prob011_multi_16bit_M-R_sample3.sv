module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output wire [31:0] yout,
    output wire done
);

    // State encoding
    localparam IDLE = 2'b00;
    localparam LOAD = 2'b01;
    localparam CALC = 2'b10;
    localparam DONE = 2'b11;

    reg [1:0] state;
    reg [3:0] bit_cnt;      // 4-bit counter (0-15)
    reg [15:0] areg;
    reg [15:0] breg;
    reg [31:0] product;
    wire [15:0][31:0] shifted_b;  // Pre-computed shifted versions

    // Generate all possible shifted versions of breg
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : shift_gen
            assign shifted_b[i] = breg << i;
        end
    endgenerate

    // State machine and datapath
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            bit_cnt <= 4'd0;
            areg <= 16'd0;
            breg <= 16'd0;
            product <= 32'd0;
        end
        else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        state <= LOAD;
                        bit_cnt <= 4'd0;
                    end
                end
                
                LOAD: begin
                    areg <= ain;
                    breg <= bin;
                    product <= 32'd0;
                    state <= CALC;
                end
                
                CALC: begin
                    if (areg[bit_cnt]) begin
                        product <= product + shifted_b[bit_cnt];
                    end
                    
                    if (bit_cnt == 4'd15) begin
                        state <= DONE;
                    end
                    else begin
                        bit_cnt <= bit_cnt + 4'd1;
                    end
                end
                
                DONE: begin
                    state <= IDLE;
                end
            endcase
        end
    end

    // Output assignments
    assign yout = product;
    assign done = (state == DONE);

endmodule