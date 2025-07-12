module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output [23:0] out_bytes,
    output done
);

reg [23:0] out_bytes_reg;
reg [1:0] state;
reg [7:0] byte1, byte2, byte3;

// Define the states
parameter IDLE = 2'b00;
parameter BYTE1 = 2'b01;
parameter BYTE2 = 2'b10;
parameter DONE = 2'b11;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        out_bytes_reg <= 24'd0;
        byte1 <= 8'd0;
        byte2 <= 8'd0;
        byte3 <= 8'd0;
    end else begin
        case (state)
            IDLE: begin
                if (in[3] == 1'b1) begin
                    byte1 <= in;
                    state <= BYTE1;
                end
            end
            BYTE1: begin
                byte2 <= in;
                state <= BYTE2;
            end
            BYTE2: begin
                byte3 <= in;
                state <= DONE;
            end
            DONE: begin
                out_bytes_reg <= {byte1, byte2, byte3};
                state <= IDLE;
            end
            default: state <= IDLE;
        endcase
    end
end

assign out_bytes = (state == DONE)? out_bytes_reg : 24'd0;
assign done = (state == DONE)? 1'b1 : 1'b0;

endmodule