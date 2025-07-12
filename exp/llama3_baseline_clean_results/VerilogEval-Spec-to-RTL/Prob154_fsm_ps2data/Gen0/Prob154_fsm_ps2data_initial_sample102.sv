module TopModule(
    input         clk,
    input         reset,
    input  [7:0]  in,
    output [23:0] out_bytes,
    output        done
);

reg [23:0] out_bytes_reg;
reg [2:0]  state_reg;
reg [2:0]  state_next;
reg [7:0]  byte1_reg;
reg [7:0]  byte2_reg;
reg [7:0]  byte3_reg;
reg        done_reg;

// Define states
parameter IDLE = 3'b000;
parameter BYTE1 = 3'b001;
parameter BYTE2 = 3'b010;
parameter BYTE3 = 3'b011;

always @(*) begin
    // Default values
    state_next = state_reg;
    done_reg = 1'b0;
    out_bytes_reg = out_bytes_reg;

    case (state_reg)
        IDLE: begin
            if (in[3] == 1'b1) begin
                state_next = BYTE1;
                byte1_reg = in;
            end
        end
        BYTE1: begin
            state_next = BYTE2;
            byte2_reg = in;
        end
        BYTE2: begin
            state_next = BYTE3;
            byte3_reg = in;
        end
        BYTE3: begin
            state_next = IDLE;
            done_reg = 1'b1;
            out_bytes_reg = {byte1_reg, byte2_reg, byte3_reg};
        end
    endcase
end

always @(posedge clk) begin
    if (reset == 1'b1) begin
        state_reg <= IDLE;
        done_reg <= 1'b0;
        out_bytes_reg <= 24'd0;
        byte1_reg <= 8'd0;
        byte2_reg <= 8'd0;
        byte3_reg <= 8'd0;
    end else begin
        state_reg <= state_next;
        done_reg <= done_reg;
        out_bytes_reg <= out_bytes_reg;
        byte1_reg <= byte1_reg;
        byte2_reg <= byte2_reg;
        byte3_reg <= byte3_reg;
    end
end

assign out_bytes = out_bytes_reg;
assign done = done_reg;

endmodule