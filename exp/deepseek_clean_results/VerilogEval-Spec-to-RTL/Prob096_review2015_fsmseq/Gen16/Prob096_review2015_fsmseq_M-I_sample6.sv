module TopModule (
    input clk,
    input reset,
    input data,
    output start_shifting
);

    reg [1:0] state;
    reg found;

    // State encoding
    localparam S0 = 2'b00; // Initial state
    localparam S1 = 2'b01; // Received '1'
    localparam S2 = 2'b10; // Received '11'
    localparam S3 = 2'b11; // Received '110'

    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            found <= 1'b0;
        end else if (!found) begin
            case (state)
                S0: state <= data ? S1 : S0;
                S1: state <= data ? S2 : S0;
                S2: state <= data ? S2 : S3;
                S3: state <= data ? S1 : S0;
            endcase
            found <= (state == S3) && data;
        end
    end

    assign start_shifting = found;

endmodule