module TopModule (
  input clk,
  input in,
  input reset,
  output reg done
);

// Define states
localparam IDLE = 2'd0;
localparam START_BIT = 2'd1;
localparam DATA_BITS = 2'd2;

// Registers
reg [1:0] state;
reg [2:0] count;

// Combinational logic
always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
        count <= 0;
        done <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (!in) begin
                    state <= START_BIT;
                    count <= 0;
                end
            end
            START_BIT: begin
                if (count < 8) begin
                    count <= count + 1;
                end else begin
                    state <= DATA_BITS;
                    count <= 0;
                end
            end
            DATA_BITS: begin
                if (count < 1) begin
                    if (in) begin
                        state <= IDLE;
                        done <= 1;
                    end
                    count <= count + 1;
                end
            end
        endcase
    end
end

endmodule