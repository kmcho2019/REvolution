module TopModule (
    input clk,
    input reset,
    input x,
    output z
);

    parameter S0 = 3'b000;
    parameter S1 = 3'b001;
    parameter S2 = 3'b010;
    parameter S3 = 3'b011;
    parameter S4 = 3'b100;

    reg [2:0] current_state, next_state;

    // State transition logic
    assign next_state = 
        (current_state == S0) ? (x ? S1 : S0) :
        (current_state == S1) ? (x ? S4 : S1) :
        (current_state == S2) ? (x ? S1 : S2) :
        (current_state == S3) ? (x ? S2 : S1) :
        (current_state == S4) ? (x ? S4 : S3) :
        S0;  // default case

    // State register
    always @(posedge clk) begin
        if (reset)
            current_state <= S0;
        else
            current_state <= next_state;
    end

    // Output logic
    assign z = (current_state == S3) || (current_state == S4);

endmodule