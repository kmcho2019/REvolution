module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // Use localparam for internal constants
    localparam [1:0] 
        A = 2'b00,
        B = 2'b01,
        C = 2'b10,
        D = 2'b11;

    reg [1:0] state;

    // Use parallel_case synthesis directive for potentially better optimization
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= A;
        end else begin
            case (state) // synthesis parallel_case
                A: state <= {1'b0, in};       // A->A (00) or A->B (01)
                B: state <= in ? B : C;        // B->B or B->C
                C: state <= {~in, in};         // C->A (00) or C->D (11)
                D: state <= {~in, in ^ 1'b1};  // D->C (10) or D->B (01)
            endcase
        end
    end

    // Output remains simple combinatorial logic
    assign out = (state == D);

endmodule