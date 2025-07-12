module TopModule (
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

// Define the states
localparam S0 = 4'd0;
localparam S1 = 4'd1;
localparam S2 = 4'd2;
localparam S3 = 4'd3;
localparam S4 = 4'd4;

reg [3:0] state;

always @ (posedge clk) begin
    if (reset) begin
        state <= S0;
        start_shifting <= 0;
    end else begin
        case (state)
            S0: if (data) state <= S1; else state <= S0;
            S1: if (data) state <= S2; else state <= S0;
            S2: if (~data) state <= S3; else state <= S0;
            S3: if (data) state <= S4; else state <= S0;
            S4: begin
                state <= S4;
                start_shifting <= 1;
            end
            default: state <= S0;
        endcase
    end
end

endmodule