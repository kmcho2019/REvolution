module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output [23:0] out_bytes,
    output done
);

reg [1:0] state;
reg [1:0] next_state;
reg [23:0] out_bytes_reg;
reg [23:0] next_out_bytes;
reg done_reg;
reg next_done;

// State machine
always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00; // IDLE
        out_bytes_reg <= 24'b0;
        done_reg <= 1'b0;
    end else begin
        state <= next_state;
        out_bytes_reg <= next_out_bytes;
        done_reg <= next_done;
    end
end

// Combinational logic
always @(*) begin
    next_state = state;
    next_out_bytes = out_bytes_reg;
    next_done = 1'b0;

    case (state)
        2'b00: begin // IDLE
            if (in[3] == 1'b1) begin
                next_state = 2'b01; // BYTE1
                next_out_bytes[23:16] = in;
            end
        end
        2'b01: begin // BYTE1
            next_state = 2'b10; // BYTE2
            next_out_bytes[15:8] = in;
        end
        2'b10: begin // BYTE2
            next_state = 2'b11; // BYTE3
            next_out_bytes[7:0] = in;
        end
        2'b11: begin // BYTE3
            next_state = 2'b00; // IDLE
            next_done = 1'b1;
        end
    endcase
end

assign out_bytes = out_bytes_reg;
assign done = done_reg;

endmodule