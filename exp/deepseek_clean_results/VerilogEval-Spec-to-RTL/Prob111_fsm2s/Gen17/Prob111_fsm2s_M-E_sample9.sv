module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

    // Shift register for state storage
    reg [1:0] state_sr;

    // Edge detection flip-flops
    reg j_ff, k_ff;
    wire j_edge, k_edge;

    always @(posedge clk) begin
        j_ff <= j;
        k_ff <= k;
    end

    assign j_edge = j & ~j_ff;  // Rising edge of j
    assign k_edge = k & ~k_ff;  // Rising edge of k

    // Shift register update logic
    always @(posedge clk) begin
        if (reset) begin
            state_sr <= 2'b00;  // Reset to OFF state
        end else begin
            case ({j_edge, k_edge})
                2'b10: state_sr <= {state_sr[0], 1'b1};  // j edge: shift in ON
                2'b01: state_sr <= {state_sr[0], 1'b0};  // k edge: shift in OFF
                default: state_sr <= {state_sr[0], state_sr[0]};  // maintain state
            endcase
        end
    end

    // Output is the current state (Moore machine)
    assign out = state_sr[0];

endmodule