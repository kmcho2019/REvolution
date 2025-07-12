module TopModule (
    input               clk,
    input               reset,
    input               data,
    output reg          start_shifting = 0
);

    localparam IDLE  = 4'b0000;
    localparam S1    = 4'b0001;
    localparam S2    = 4'b0010;
    localparam S3    = 4'b0011;
    localparam FOUND = 4'b0100;

    reg [3:0] state = IDLE;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            start_shifting <= 0;
        end
        else begin
            case (state)
                IDLE: begin
                    if (data) begin
                        state <= S1;
                    end
                end
                S1: begin
                    if (data) begin
                        state <= S2;
                    end
                    else begin
                        state <= IDLE;
                    end
                end
                S2: begin
                    if (!data) begin
                        state <= S3;
                    end
                    else begin
                        state <= IDLE;
                    end
                end
                S3: begin
                    if (data) begin
                        state <= FOUND;
                    end
                    else begin
                        state <= IDLE;
                    end
                end
                FOUND: begin
                    start_shifting <= 1;
                end
                default: begin
                    state <= IDLE;
                end
            endcase
        end
    end

endmodule