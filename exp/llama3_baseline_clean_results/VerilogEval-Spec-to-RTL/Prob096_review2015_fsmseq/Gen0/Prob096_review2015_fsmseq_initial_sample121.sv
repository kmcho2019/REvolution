module TopModule (
    input  clk,
    input  reset,
    input  data,
    output start_shifting
);

reg [1:0] state; // State register
reg start_shifting_reg; // Register for output

// Define states
localparam S0 = 2'b00;
localparam S1 = 2'b01;
localparam S2 = 2'b10;
localparam S3 = 2'b11;
localparam S4 = 2'b00; // After finding 1101, stay in S0 with start_shifting=1

always @(posedge clk) begin
    if (reset) begin
        state <= S0;
        start_shifting_reg <= 0;
    end else begin
        case (state)
            S0: begin
                if (data == 1'b1) begin
                    state <= S1;
                end else begin
                    state <= S0;
                end
            end
            S1: begin
                if (data == 1'b1) begin
                    state <= S2;
                end else if (data == 1'b0) begin
                    state <= S0;
                end
            end
            S2: begin
                if (data == 1'b0) begin
                    state <= S3;
                end else if (data == 1'b1) begin
                    state <= S1;
                end
            end
            S3: begin
                if (data == 1'b1) begin
                    state <= S0; // Match found, transition to S0 and set start_shifting
                    start_shifting_reg <= 1;
                end else if (data == 1'b0) begin
                    state <= S0; // No match, reset to S0
                end
            end
            default: state <= S0;
        endcase
    end
end

// Continuous assignment for output
assign start_shifting = start_shifting_reg;

endmodule