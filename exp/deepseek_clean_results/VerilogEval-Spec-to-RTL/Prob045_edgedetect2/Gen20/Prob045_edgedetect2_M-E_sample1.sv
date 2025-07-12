module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

    // State encoding for each bit:
    // 00: Stable 0
    // 01: Rising edge detected
    // 10: Falling edge detected
    // 11: Stable 1
    reg [1:0] state [7:0];

    integer i;
    always @(posedge clk) begin
        for (i = 0; i < 8; i = i + 1) begin
            case (state[i])
                2'b00: begin
                    if (in[i]) begin
                        state[i] <= 2'b01;  // Rising edge
                        anyedge[i] <= 1'b1;
                    end else begin
                        anyedge[i] <= 1'b0;
                    end
                end
                2'b01: begin
                    if (in[i]) begin
                        state[i] <= 2'b11;  // Now stable 1
                        anyedge[i] <= 1'b0;
                    end else begin
                        state[i] <= 2'b10;  // Falling edge
                        anyedge[i] <= 1'b1;
                    end
                end
                2'b10: begin
                    if (in[i]) begin
                        state[i] <= 2'b01;  // Rising edge
                        anyedge[i] <= 1'b1;
                    end else begin
                        state[i] <= 2'b00;  // Now stable 0
                        anyedge[i] <= 1'b0;
                    end
                end
                2'b11: begin
                    if (!in[i]) begin
                        state[i] <= 2'b10;  // Falling edge
                        anyedge[i] <= 1'b1;
                    end else begin
                        anyedge[i] <= 1'b0;
                    end
                end
            endcase
        end
    end

    // Initialize all states to match initial input (assuming reset handled elsewhere)
    initial begin
        for (i = 0; i < 8; i = i + 1) begin
            state[i] = in[i] ? 2'b11 : 2'b00;
            anyedge[i] = 1'b0;
        end
    end

endmodule