module TopModule (
    input           clk,        // Clock signal
    input           areset,     // Asynchronous reset
    input           load,       // Synchronous load signal
    input           ena,        // Synchronous enable signal
    input   [3:0]   data,       // 4-bit data input
    output  [3:0]   q           // 4-bit output
);

// 4-bit register using D-type flip-flops
reg [3:0] q_reg;  // Register to hold the shift register's value

// Multiplexers to select between load data and shifted register value
wire [3:0] mux_out1;
wire [3:0] mux_out2;

// First multiplexer: select between load data and current register value
assign mux_out1 = load ? data : q_reg;

// Shift the register value to the right
wire [3:0] shifted_reg;
assign shifted_reg = {1'b0, q_reg[3:1]};

// Second multiplexer: select between the output of the first multiplexer and the shifted register value
assign mux_out2 = ena ? shifted_reg : mux_out1;

// Asynchronous reset, synchronous load and shift operations
always @(posedge clk or posedge areset) begin
    if (areset) begin
        // Asynchronous reset to zero
        q_reg <= 4'b0;
    end else begin
        // Synchronous operations
        q_reg <= mux_out2;
    end
end

// Assign output
assign q = q_reg;

endmodule