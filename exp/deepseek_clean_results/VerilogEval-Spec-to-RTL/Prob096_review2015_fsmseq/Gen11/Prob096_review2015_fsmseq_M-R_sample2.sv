module TopModule (
    input clk,
    input reset,
    input data,
    output start_shifting
);

    // State encoding for sequence detection
    localparam S0 = 3'b000; // Initial state
    localparam S1 = 3'b001; // Received '1'
    localparam S2 = 3'b010; // Received '11'
    localparam S3 = 3'b011; // Received '110'
    localparam S4 = 3'b100; // Received '1101' (pattern found)

    reg [2:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
        end else begin
            case (state)
                S0: state <= data ? S1 : S0;
                S1: state <= data ? S2 : S0;
                S2: state <= data ? S2 : S3;
                S3: state <= data ? S4 : S0;
                S4: state <= S4; // Stay in found state
                default: state <= S0;
            endcase
        end
    end

    assign start_shifting = (state == S4);

endmodule