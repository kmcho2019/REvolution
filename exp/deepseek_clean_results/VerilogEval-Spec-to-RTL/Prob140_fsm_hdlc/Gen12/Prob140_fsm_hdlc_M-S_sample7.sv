module TopModule (
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

    // State encoding (7 states)
    parameter S0 = 3'b000;
    parameter S1 = 3'b001;
    parameter S2 = 3'b010;
    parameter S3 = 3'b011;
    parameter S4 = 3'b100;
    parameter S5 = 3'b101;
    parameter S6 = 3'b110;  // Represents 6+ consecutive 1s

    reg [2:0] state;

    // State transition logic
    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else begin
            case (state)
                S0: state <= in ? S1 : S0;
                S1: state <= in ? S2 : S0;
                S2: state <= in ? S3 : S0;
                S3: state <= in ? S4 : S0;
                S4: state <= in ? S5 : S0;
                S5: state <= in ? S6 : S0;
                S6: state <= in ? S6 : S0;
                default: state <= S0;
            endcase
        end
    end

    // Combinational output logic
    assign disc = (state == S5) && !in;
    assign flag = (state == S6) && !in;
    assign err = (state == S6) && in;

endmodule