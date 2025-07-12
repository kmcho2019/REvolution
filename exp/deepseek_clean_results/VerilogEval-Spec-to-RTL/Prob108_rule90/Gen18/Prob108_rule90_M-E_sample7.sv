module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

parameter WIDTH = 512;
parameter IDLE = 2'b00;
parameter COMPUTE = 2'b01;
parameter DONE = 2'b10;

reg [1:0] state;
reg [8:0] counter; // 9 bits for 0-511 count
reg [511:0] shadow_reg;
wire next_bit;

// FSM control
always @(posedge clk) begin
    case (state)
        IDLE: begin
            if (load) begin
                q <= data;
                state <= IDLE;
            end else begin
                shadow_reg <= q;
                counter <= 0;
                state <= COMPUTE;
            end
        end
        COMPUTE: begin
            shadow_reg <= {shadow_reg[510:0], next_bit};
            if (counter == WIDTH-1)
                state <= DONE;
            else
                counter <= counter + 1;
        end
        DONE: begin
            q <= shadow_reg;
            state <= IDLE;
        end
    endcase
end

// Compute next state for current cell
assign next_bit = (counter == 0) ? (1'b0 ^ shadow_reg[1]) :  // left boundary
                 (counter == WIDTH-1) ? (shadow_reg[WIDTH-2] ^ 1'b0) : // right boundary
                 (shadow_reg[counter-1] ^ shadow_reg[counter+1]);

endmodule