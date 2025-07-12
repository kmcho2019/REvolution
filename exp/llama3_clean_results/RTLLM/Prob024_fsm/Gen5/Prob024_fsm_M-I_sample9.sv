module fsm(
    input logic IN,
    input logic CLK,
    input logic RST,
    output logic MATCH
);

// Binary encoding for the states
reg [2:0] state;
reg [2:0] next_state;

// Always block for sequential logic
always_ff @(posedge CLK) begin
    if (RST) begin
        state <= 3'b000; // IDLE
        MATCH <= 1'b0;
    end else begin
        state <= next_state;
        MATCH <= 1'b0;
    end
end

// Combinational logic
always_comb begin
    case (state)
        3'b000: begin // IDLE
            if (IN) begin
                next_state = 3'b001; // S1
            end else begin
                next_state = 3'b000; // IDLE
            end
        end
        3'b001: begin // S1
            if (~IN) begin
                next_state = 3'b010; // S2
            end else begin
                next_state = 3'b000; // IDLE
            end
        end
        3'b010: begin // S2
            if (~IN) begin
                next_state = 3'b011; // S3
            end else begin
                next_state = 3'b000; // IDLE
            end
        end
        3'b011: begin // S3
            if (IN) begin
                next_state = 3'b100; // S4
            end else begin
                next_state = 3'b000; // IDLE
            end
        end
        3'b100: begin // S4
            if (IN) begin
                next_state = 3'b101; // S5
                MATCH = 1'b1;
            end else begin
                next_state = 3'b000; // IDLE
            end
        end
        3'b101: begin // S5
            next_state = 3'b000; // IDLE
        end
        default: next_state = 3'b000; // IDLE
    endcase
end

endmodule