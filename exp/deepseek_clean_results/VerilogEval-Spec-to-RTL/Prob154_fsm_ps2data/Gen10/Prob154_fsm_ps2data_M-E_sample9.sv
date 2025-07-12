module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output done
);

    // Gray code state encoding for low-power transitions
    localparam IDLE  = 2'b00;
    localparam BYTE1 = 2'b01;
    localparam BYTE2 = 2'b11;  // Gray code progression
    localparam DONE  = 2'b10;

    reg [1:0] state;
    reg [23:0] shift_reg;

    // Combinatorial done signal
    assign done = (state == DONE);

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 24'bx;
        end else begin
            case (state)
                IDLE: begin
                    if (in[3]) begin
                        shift_reg <= {in, 16'bx};  // Store first byte
                        state <= BYTE1;
                    end
                end
                
                BYTE1: begin
                    shift_reg <= {shift_reg[23:16], in, 8'bx};  // Shift in second byte
                    state <= BYTE2;
                end
                
                BYTE2: begin
                    shift_reg <= {shift_reg[23:8], in};  // Shift in third byte
                    state <= DONE;
                end
                
                DONE: begin
                    out_bytes <= shift_reg;  // Output captured bytes
                    state <= IDLE;
                end
            endcase
        end
    end

endmodule