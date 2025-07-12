module TopModule (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    reg [1:0] state;

    // State encoding
    localparam S0 = 2'b00;  // Initial state or after 0
    localparam S1 = 2'b01;  // 1
    localparam S2 = 2'b10;  // 11
    localparam S3 = 2'b11;  // 11111 (5 or more 1s)

    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            disc <= 0;
            flag <= 0;
            err <= 0;
        end else begin
            // Default outputs
            disc <= 0;
            flag <= 0;
            err <= 0;

            // State transitions
            case (state)
                S0: state <= in ? S1 : S0;
                S1: state <= in ? S2 : S0;
                S2: state <= in ? S3 : S0;
                S3: begin
                    if (!in) begin
                        disc <= 1;
                        state <= S0;
                    end else begin
                        flag <= (state == S3);
                        err <= 1;
                    end
                end
            endcase
        end
    end

endmodule