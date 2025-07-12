module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output reg  MATCH
);

    // States: prefix length matched in "10011"
    localparam S0 = 3'd0; // no match
    localparam S1 = 3'd1; // matched '1'
    localparam S2 = 3'd2; // matched '10'
    localparam S3 = 3'd3; // matched '100'
    localparam S4 = 3'd4; // matched '1001'

    reg [2:0] state;

    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            state <= S0;
            MATCH <= 1'b0;
        end else begin
            case (state)
                S0: begin
                    if (IN)
                        state <= S1;
                    else
                        state <= S0;
                    MATCH <= 1'b0;
                end

                S1: begin
                    if (~IN)
                        state <= S2;
                    else
                        state <= S1;
                    MATCH <= 1'b0;
                end

                S2: begin
                    if (~IN)
                        state <= S3;
                    else
                        state <= S1;
                    MATCH <= 1'b0;
                end

                S3: begin
                    if (IN)
                        state <= S4;
                    else
                        state <= S0;
                    MATCH <= 1'b0;
                end

                S4: begin
                    if (IN) begin
                        MATCH <= 1'b1;
                        state <= S1;
                    end else begin
                        MATCH <= 1'b0;
                        state <= S2;
                    end
                end

                default: begin
                    state <= S0;
                    MATCH <= 1'b0;
                end
            endcase
        end
    end

endmodule