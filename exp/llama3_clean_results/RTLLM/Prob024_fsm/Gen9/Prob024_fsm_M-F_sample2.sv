module fsm(
    input logic IN,
    input logic CLK,
    input logic RST,
    output logic MATCH
);

// 3-bit register to keep track of the current state
logic [2:0] state;

// Initial state
localparam S0 = 3'b000;
// States for each bit in the target sequence
localparam S1 = 3'b001;
localparam S2 = 3'b010;
localparam S3 = 3'b011;
localparam S4 = 3'b100;
localparam S5 = 3'b101;

// Asynchronous reset
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= S0;
        MATCH <= 1'b0;
    end else begin
        case (state)
            S0: begin
                if (IN) begin
                    state <= S1;
                end else begin
                    state <= S0;
                end
                MATCH <= 1'b0;
            end
            S1: begin
                if (!IN) begin
                    state <= S2;
                end else begin
                    state <= S0;
                end
                MATCH <= 1'b0;
            end
            S2: begin
                if (!IN) begin
                    state <= S3;
                end else begin
                    state <= S0;
                end
                MATCH <= 1'b0;
            end
            S3: begin
                if (IN) begin
                    state <= S4;
                end else begin
                    state <= S0;
                end
                MATCH <= 1'b0;
            end
            S4: begin
                if (IN) begin
                    state <= S5;
                end else begin
                    state <= S0;
                end
                MATCH <= 1'b0;
            end
            S5: begin
                state <= S0;
                MATCH <= 1'b1;
            end
            default: begin
                state <= S0;
                MATCH <= 1'b0;
            end
        endcase
    end
end

endmodule