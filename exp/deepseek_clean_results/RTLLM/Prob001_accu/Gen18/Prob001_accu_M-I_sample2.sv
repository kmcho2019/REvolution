module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

reg [9:0] accumulator;
reg [3:0] state;  // One-hot encoding: bit0=1st, bit1=2nd, bit2=3rd, bit3=4th
wire [9:0] next_accum;
wire state_advance;

// Clock gating logic
wire gated_clk = clk & (valid_in | (|state));

// One-hot state transition logic
assign state_advance = valid_in & (|state);
wire [3:0] next_state = !rst_n ? 4'b0 : 
                       !(|state) ? 4'b0001 : 
                       {state[2:0], state[3]};

// Accumulator logic
assign next_accum = (!(|state)) ? {2'b0, data_in} : 
                   accumulator + data_in;

// Output logic
always @(posedge gated_clk or negedge rst_n) begin
    if (!rst_n) begin
        accumulator <= 10'b0;
        state <= 4'b0;
        data_out <= 10'b0;
    end
    else begin
        state <= next_state;
        
        if (valid_in) begin
            accumulator <= next_accum;
            
            if (state[2]) begin  // 3rd input (next will be 4th)
                data_out <= next_accum;  // Pre-calculate output
            end
        end
    end
end

// Valid out is purely combinatorial
assign valid_out = state[3] & valid_in;

endmodule