module TopModule (
    input clk,
    input L,
    input q_in,
    input r_in,
    output Q
);

    parameter FEEDBACK_MODE = 0; // 0: q_in, 1: q_in (for q[1]), 2: q_in (for q[2])
    reg q;
    wire feedback;
    wire mux_out;
    
    // Select appropriate feedback based on parameter
    assign feedback = (FEEDBACK_MODE == 0) ? q_in : q_in;
    
    assign mux_out = L ? r_in : feedback;
    
    always @(posedge clk) begin
        q <= mux_out;
    end
    
    assign Q = q;

endmodule