module DFF_shift_load (
    input clk,
    input load,       // Active high load signal
    input d_in,       // Shift input (used if load==0)
    input parallel_in, // Parallel data input (used if load==1)
    output reg q_out
);
    always @(posedge clk) begin
        if (load)
            q_out <= parallel_in;
        else
            q_out <= d_in;
    end
endmodule

module TopModule (
    input clk,
    input [7:0] d,
    output [7:0] q
);
    wire load;
    assign load = 1'b1; // Always load parallel input on every clock

    // Shift chain connections when load=0 (not used here)
    wire [7:0] shift_in;
    // Shift left (MSB to LSB) connections, used if load=0
    assign shift_in[0] = 1'b0; // Could be serial input if needed
    genvar i;
    generate
        for (i = 1; i < 8; i = i +1) begin : shift_chain
            assign shift_in[i] = q[i-1];
        end
    endgenerate

    // Instantiate 8 DFFs with parallel load and shift capability
    // Here load=1 so flip-flops load parallel input 'd' at clk edge
    genvar j;
    generate
        for (j = 0; j < 8; j = j + 1) begin : dffs
            DFF_shift_load dff_inst (
                .clk(clk),
                .load(load),
                .d_in(shift_in[j]),
                .parallel_in(d[j]),
                .q_out(q[j])
            );
        end
    endgenerate
endmodule