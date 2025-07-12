module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output wire [31:0] yout,
    output wire done
);

    // State machine definitions
    localparam IDLE  = 2'b00;
    localparam WORKING = 2'b01;
    localparam DONE  = 2'b10;

    reg [1:0] state;
    reg [3:0] bit_pos;      // Now only needs 4 bits (0-15)
    reg [15:0] areg;
    reg [15:0] breg;
    reg [31:0] acc;
    wire [15:0][31:0] shifted_b; // Pre-computed shifted versions

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
            bit_pos <= 4'd0;
            areg <= 16'd0;
            breg <= 16'd0;
            acc <= 32'd0;
        end
        else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        state <= WORKING;
                        areg <= ain;
                        breg <= bin;
                        acc <= 32'd0;
                        bit_pos <= 4'd0;
                    end
                end
                
                WORKING: begin
                    if (areg[bit_pos]) begin
                        acc <= acc + shifted_b[bit_pos];
                    end
                    
                    if (bit_pos == 4'd15) begin
                        state <= DONE;
                    end
                    else begin
                        bit_pos <= bit_pos + 4'd1;
                    end
                end
                
                DONE: begin
                    state <= IDLE;
                end
            endcase
        end
    end

    // Output assignments
    assign yout = (state == DONE) ? acc : 32'd0;
    assign done = (state == DONE);

endmodule