module TopModule (
    input clk,
    input reset,
    input x,
    output z
);

    // State encoding
    parameter S0 = 3'b000;
    parameter S1 = 3'b001;
    parameter S2 = 3'b010;
    parameter S3 = 3'b011;
    parameter S4 = 3'b100;

    reg [2:0] state;
    wire [2:0] next_state_x0;
    wire [2:0] next_state_x1;
    wire [2:0] next_state;

    // Compute next state for x=0 case
    assign next_state_x0 = 
        (state == S0) ? S0 :
        (state == S1) ? S1 :
        (state == S2) ? S2 :
        (state == S3) ? S1 :
        (state == S4) ? S3 :
        S0; // Default

    // Compute next state for x=1 case
    assign next_state_x1 = 
        (state == S0) ? S1 :
        (state == S1) ? S4 :
        (state == S2) ? S1 :
        (state == S3) ? S2 :
        (state == S4) ? S4 :
        S0; // Default

    // Select appropriate next state based on x
    assign next_state = x ? next_state_x1 : next_state_x0;

    // State register update
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
        end else begin
            state <= next_state;
        end
    end

    // Output logic remains the same
    assign z = (state == S3) || (state == S4);

endmodule