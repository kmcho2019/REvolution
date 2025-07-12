module TopModule (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    reg [2:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state <= 0;
            disc <= 0;
            flag <= 0;
            err <= 0;
        end else begin
            // Default outputs
            disc <= 0;
            flag <= 0;
            err <= 0;
            
            // State transitions and output logic
            case (state)
                0: state <= in ? 1 : 0;
                1: state <= in ? 2 : 0;
                2: state <= in ? 3 : 0;
                3: state <= in ? 4 : 0;
                4: state <= in ? 5 : 0;
                5: begin
                    state <= in ? 6 : 0;
                    disc <= ~in;
                end
                6: begin
                    state <= in ? 7 : 0;
                    flag <= ~in;
                end
                7: begin
                    state <= in ? 7 : 0;
                    err <= in;
                end
                default: state <= 0;
            endcase
        end
    end

endmodule