module fsm(
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

reg [3:0] state;

// Define states
localparam IDLE = 4'd0;
localparam S1 = 4'd1;
localparam S2 = 4'd2;
localparam S3 = 4'd3;
localparam S4 = 4'd4;
localparam S5 = 4'd5;

always @(posedge CLK or posedge RST) begin
    if(RST) begin
        state <= IDLE;
        MATCH <= 1'd0;
    end else begin
        case(state)
            IDLE: begin
                if(IN == 1'd1) begin
                    state <= S1;
                end else begin
                    state <= IDLE;
                end
                MATCH <= 1'd0;
            end
            S1: begin
                if(IN == 1'd0) begin
                    state <= S2;
                end else begin
                    state <= IDLE;
                end
                MATCH <= 1'd0;
            end
            S2: begin
                if(IN == 1'd0) begin
                    state <= S3;
                end else begin
                    state <= IDLE;
                end
                MATCH <= 1'd0;
            end
            S3: begin
                if(IN == 1'd1) begin
                    state <= S4;
                end else begin
                    state <= IDLE;
                end
                MATCH <= 1'd0;
            end
            S4: begin
                if(IN == 1'd1) begin
                    state <= S5;
                    MATCH <= 1'd1;
                end else begin
                    state <= IDLE;
                end
            end
            S5: begin
                MATCH <= 1'd0;
                if(IN == 1'd1) begin
                    state <= S1;
                end else if(IN == 1'd0) begin
                    state <= S2;
                end else begin
                    state <= IDLE;
                end
            end
            default: begin
                state <= IDLE;
                MATCH <= 1'd0;
            end
        endcase
    end
end

endmodule