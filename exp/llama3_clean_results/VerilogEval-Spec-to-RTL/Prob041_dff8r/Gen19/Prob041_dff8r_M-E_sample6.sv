// Define a module for a single D flip-flop
module DFF(
    input clk,
    input reset,
    input d,
    output logic q
);

    (* synthesis_attribute = "optimize_area" *)
    logic q_int;
    always_ff @(posedge clk) begin
        if (reset) begin
            q_int <= 1'b0;
        end else begin
            q_int <= d;
        end
    end
    assign q = q_int;

endmodule

// Define the TopModule with a shift register-based architecture
module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output logic [7:0] q
);

    // Chain 8 D flip-flops together in a shift register configuration
    logic [7:0] q_int;
    DFF dff0(
       .clk(clk),
       .reset(reset),
       .d(d[0]),
       .q(q_int[0])
    );
    DFF dff1(
       .clk(clk),
       .reset(reset),
       .d(q_int[0]),
       .q(q_int[1])
    );
    DFF dff2(
       .clk(clk),
       .reset(reset),
       .d(q_int[1]),
       .q(q_int[2])
    );
    DFF dff3(
       .clk(clk),
       .reset(reset),
       .d(q_int[2]),
       .q(q_int[3])
    );
    DFF dff4(
       .clk(clk),
       .reset(reset),
       .d(q_int[3]),
       .q(q_int[4])
    );
    DFF dff5(
       .clk(clk),
       .reset(reset),
       .d(q_int[4]),
       .q(q_int[5])
    );
    DFF dff6(
       .clk(clk),
       .reset(reset),
       .d(q_int[5]),
       .q(q_int[6])
    );
    DFF dff7(
       .clk(clk),
       .reset(reset),
       .d(q_int[6]),
       .q(q_int[7])
    );

    // Assign the outputs of the flip-flops to the output vector
    assign q = {q_int[7], q_int[6], q_int[5], q_int[4], q_int[3], q_int[2], q_int[1], q_int[0]};

endmodule