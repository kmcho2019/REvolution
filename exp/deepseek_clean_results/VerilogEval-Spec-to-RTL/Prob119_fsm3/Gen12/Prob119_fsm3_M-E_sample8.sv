module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // One-hot state encoding
    parameter [3:0] S_A = 4'b0001;
    parameter [3:0] S_B = 4'b0010;
    parameter [3:0] S_C = 4'b0100;
    parameter [3:0] S_D = 4'b1000;

    reg [3:0] state;

    // Next state logic (combinational)
    wire [3:0] next_state;
    assign next_state = (state == S_A) ? (in ? S_B : S_A) :
                       (state == S_B) ? (in ? S_B : S_C) :
                       (state == S_C) ? (in ? S_D : S_A) :
                       (state == S_D) ? (in ? S_B : S_C) : S_A;

    // State transition (sequential)
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= S_A;
        end else begin
            state <= next_state;
        end
    end

    // Output logic (combinational)
    assign out = (state == S_D);

endmodule