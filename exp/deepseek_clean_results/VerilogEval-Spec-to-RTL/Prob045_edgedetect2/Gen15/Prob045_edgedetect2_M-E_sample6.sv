module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

    // State encoding: 00=0, 01=1, 10=edge detected
    reg [1:0] state [0:7];
    integer i;

    always @(posedge clk) begin
        for (i = 0; i < 8; i = i + 1) begin
            case (state[i])
                2'b00: begin // Previous state was 0
                    if (in[i]) begin
                        state[i] <= 2'b10; // Edge detected
                        anyedge[i] <= 1'b1;
                    end else begin
                        anyedge[i] <= 1'b0;
                    end
                end
                2'b01: begin // Previous state was 1
                    if (!in[i]) begin
                        state[i] <= 2'b10; // Edge detected
                        anyedge[i] <= 1'b1;
                    end else begin
                        anyedge[i] <= 1'b0;
                    end
                end
                2'b10: begin // Edge state
                    anyedge[i] <= 1'b0;
                    state[i] <= {1'b0, in[i]}; // Move to new stable state
                end
                default: begin
                    state[i] <= {1'b0, in[i]};
                    anyedge[i] <= 1'b0;
                end
            endcase
        end
    end

    // Initialize all states
    initial begin
        for (i = 0; i < 8; i = i + 1) begin
            state[i] = {1'b0, in[i]};
            anyedge[i] = 1'b0;
        end
    end

endmodule