module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // State encoding
    parameter [1:0] S_A = 2'b00,
                    S_B = 2'b01,
                    S_C = 2'b10,
                    S_D = 2'b11;

    reg [1:0] current_state;
    wire [1:0] next_state_0, next_state_1;
    wire [1:0] next_state;

    // Parallel next state prediction for both input conditions
    assign next_state_0 = (current_state == S_A) ? S_A :
                         (current_state == S_B) ? S_C :
                         (current_state == S_C) ? S_A :
                         S_C;  // current_state == S_D

    assign next_state_1 = (current_state == S_A) ? S_B :
                         (current_state == S_B) ? S_B :
                         (current_state == S_C) ? S_D :
                         S_B;  // current_state == S_D

    // Mux to select appropriate next state based on input
    assign next_state = in ? next_state_1 : next_state_0;

    // State register with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= S_A;
        end else begin
            current_state <= next_state;
        end
    end

    // Output logic
    assign out = (current_state == S_D);

endmodule