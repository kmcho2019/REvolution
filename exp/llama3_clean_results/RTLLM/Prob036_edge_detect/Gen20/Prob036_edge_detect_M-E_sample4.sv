module edge_detect (
    input  clk,          // Clock signal
    input  rst_n,        // Reset signal (active low)
    input  a,           // Input signal to detect edges
    output reg rise,     // Output signal indicating a rising edge
    output reg down      // Output signal indicating a falling edge
);

reg [1:0] state;        // Register to hold the current and previous states of 'a'

// Sequential logic to detect edges
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin        // Reset condition
        state <= 2'b00;
        rise <= 1'b0;
        down <= 1'b0;
    end else begin
        case (state)
            2'b00: begin
                if (a) begin
                    state <= 2'b01;
                    rise <= 1'b1;
                    down <= 1'b0;
                end else begin
                    state <= 2'b00;
                    rise <= 1'b0;
                    down <= 1'b0;
                end
            end
            2'b01: begin
                if (~a) begin
                    state <= 2'b10;
                    rise <= 1'b0;
                    down <= 1'b1;
                end else begin
                    state <= 2'b01;
                    rise <= 1'b0;
                    down <= 1'b0;
                end
            end
            2'b10: begin
                if (a) begin
                    state <= 2'b01;
                    rise <= 1'b1;
                    down <= 1'b0;
                end else begin
                    state <= 2'b00;
                    rise <= 1'b0;
                    down <= 1'b0;
                end
            end
            2'b11: begin
                if (~a) begin
                    state <= 2'b10;
                    rise <= 1'b0;
                    down <= 1'b1;
                end else begin
                    state <= 2'b11;
                    rise <= 1'b0;
                    down <= 1'b0;
                end
            end
        endcase
    end
end

endmodule