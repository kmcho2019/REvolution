module TopModule (
    input [2:0] y,  // Current state in binary encoding (A=000, B=001, ..., F=101)
    input w,       // Input signal
    output reg Y1,  // Next state y[0] (LSB)
    output reg Y3   // Next state y[2] (MSB)
);

    // State definitions
    parameter A = 3'b000;
    parameter B = 3'b001;
    parameter C = 3'b010;
    parameter D = 3'b011;
    parameter E = 3'b100;
    parameter F = 3'b101;

    always @(*) begin
        // Default outputs
        Y1 = 1'b0;
        Y3 = 1'b0;
        
        case (y)
            A: begin
                if (~w) begin
                    Y1 = 1'b0;  // Transition to B (001)
                    Y3 = 1'b0;
                end else begin
                    Y1 = 1'b1;  // Stay in A (000)
                    Y3 = 1'b0;
                end
            end
            B: begin
                if (~w) begin
                    Y1 = 1'b0;  // Transition to C (010)
                    Y3 = 1'b1;
                end else begin
                    Y1 = 1'b1;  // Transition to D (011)
                    Y3 = 1'b1;
                end
            end
            C: begin
                if (~w) begin
                    Y1 = 1'b0;  // Transition to E (100)
                    Y3 = 1'b0;
                end else begin
                    Y1 = 1'b1;  // Transition to D (011)
                    Y3 = 1'b1;
                end
            end
            D: begin
                if (~w) begin
                    Y1 = 1'b0;  // Transition to F (101)
                    Y3 = 1'b1;
                end else begin
                    Y1 = 1'b1;  // Transition to A (000)
                    Y3 = 1'b0;
                end
            end
            E: begin
                if (~w) begin
                    Y1 = 1'b0;  // Stay in E (100)
                    Y3 = 1'b0;
                end else begin
                    Y1 = 1'b1;  // Transition to D (011)
                    Y3 = 1'b1;
                end
            end
            F: begin
                if (~w) begin
                    Y1 = 1'b0;  // Transition to C (010)
                    Y3 = 1'b1;
                end else begin
                    Y1 = 1'b1;  // Transition to D (011)
                    Y3 = 1'b1;
                end
            end
            default: begin
                Y1 = 1'b1;  // Reset to A (000)
                Y3 = 1'b0;
            end
        endcase
    end

endmodule