module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

reg [1:0] state; // current state
localparam S0 = 2'b00; // initial state
localparam S1 = 2'b01; // found '1'
localparam S2 = 2'b10; // found '1' followed by '1'
localparam S3 = 2'b11; // found '1' followed by '1' followed by '0'
localparam S4 = 2'b11; // found '1' followed by '1' followed by '0' followed by '1'

always @(posedge clk) begin
    if (reset) begin
        state <= S0;
        start_shifting <= 0;
    end else begin
        case (state)
            S0: begin
                if (data) state <= S1;
                else state <= S0;
            end
            S1: begin
                if (data) state <= S2;
                else state <= S0;
            end
            S2: begin
                if (!data) state <= S3;
                else state <= S1;
            end
            S3: begin
                if (data) state <= S4;
                else state <= S0;
            end
            S4: begin
                start_shifting <= 1;
            end
            default: state <= S0;
        endcase
    end
end

always @(posedge clk) begin
    if (reset) start_shifting <= 0;
    else if (state == S4) start_shifting <= 1;
end

endmodule