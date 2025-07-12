module fsm(
    input logic IN,
    input logic CLK,
    input logic RST,
    output logic MATCH
);

// Binary encoding for the states
logic [1:0] state, next_state;

// Asynchronous reset
always @(RST or posedge CLK) begin
    if (RST) begin
        state <= 2'b00;
        MATCH <= 1'b0;
    end else begin
        state <= next_state;
        MATCH <= 1'b0;
    end
end

// Combinational logic
always_comb begin
    case (state)
        2'b00: begin // IDLE
            if (IN) begin
                next_state = 2'b01;
            end else begin
                next_state = 2'b00;
            end
        end
        2'b01: begin // S1
            if (~IN) begin
                next_state = 2'b10;
            end else begin
                next_state = 2'b00;
            end
        end
        2'b10: begin // S2
            if (~IN) begin
                next_state = 2'b10;
            end else begin
                next_state = 2'b11;
            end
        end
        2'b11: begin // S3
            if (IN) begin
                next_state = 2'b00;
            end else begin
                next_state = 2'b00;
            end
        end
    endcase
end

// Synchronous logic for MATCH
always_ff @(posedge CLK) begin
    if (RST) begin
        MATCH <= 1'b0;
    end else if (state == 2'b11 && IN) begin
        MATCH <= 1'b1;
    end
end

endmodule