module TopModule (
    input        clk,
    input        resetn,
    input  [2:0] r,
    output [2:0] g
);

// One-hot state encoding
localparam A = 4'b0001;
localparam B = 4'b0010;
localparam C = 4'b0100;
localparam D = 4'b1000;

reg [3:0] state, next_state;

// Next state logic implemented with combinational continuous assignments
wire next_A = (!r[0] && !r[1] && !r[2]) || 
              (state[1] && !r[0]) ||  // B and no request from device 0
              (state[2] && !r[1]) ||  // C and no request from device 1
              (state[3] && !r[2]);    // D and no request from device 2

wire next_B = (state[0] && r[0]) || (state[1] && r[0]);
wire next_C = (state[0] && !r[0] && r[1]) || (state[2] && r[1]);
wire next_D = (state[0] && !r[0] && !r[1] && r[2]) || (state[3] && r[2]);

assign next_state = {next_D, next_C, next_B, next_A};

// State register with synchronous active-low reset
always @(posedge clk) begin
    if (!resetn)
        state <= A;
    else
        state <= next_state;
end

// Output logic: g[i] = 1 if in state granting that device
assign g = {state[3], state[2], state[1]};

endmodule