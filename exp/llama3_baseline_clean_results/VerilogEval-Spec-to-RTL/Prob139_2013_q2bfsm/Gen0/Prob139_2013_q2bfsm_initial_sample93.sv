module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

reg [2:0] state; // state register
reg [1:0] counter; // counter for clock cycles
reg x_seq_detected; // flag for x sequence detection
reg y_detected; // flag for y detection

// state enumeration
parameter STATE_A = 3'b000; // initial state
parameter STATE_B = 3'b001; // set f to 1
parameter STATE_C = 3'b010; // monitor x input
parameter STATE_D = 3'b011; // set g to 1 and monitor y input
parameter STATE_E = 3'b100; // g permanently set to 1
parameter STATE_F = 3'b101; // g permanently set to 0

always @(posedge clk) begin
    if (~resetn) begin // reset asserted
        state <= STATE_A;
        counter <= 0;
        x_seq_detected <= 0;
        y_detected <= 0;
        f <= 0;
        g <= 0;
    end else begin // reset de-asserted
        case (state)
            STATE_A: begin // initial state
                state <= STATE_B;
                f <= 0;
                g <= 0;
            end
            STATE_B: begin // set f to 1
                state <= STATE_C;
                f <= 1;
                g <= 0;
            end
            STATE_C: begin // monitor x input
                if (x == 1 && counter == 0) begin
                    counter <= counter + 1;
                end else if (x == 0 && counter == 1) begin
                    counter <= counter + 1;
                end else if (x == 1 && counter == 2) begin
                    x_seq_detected <= 1;
                    state <= STATE_D;
                    counter <= 0;
                end else if (x == 1 && counter == 0) begin
                    counter <= 1;
                end else begin
                    counter <= 0;
                end
                f <= 0;
                g <= 0;
            end
            STATE_D: begin // set g to 1 and monitor y input
                g <= 1;
                if (y == 1) begin
                    y_detected <= 1;
                    state <= STATE_E;
                end else if (counter == 1) begin
                    state <= STATE_F;
                end else begin
                    counter <= counter + 1;
                end
                f <= 0;
            end
            STATE_E: begin // g permanently set to 1
                g <= 1;
                f <= 0;
            end
            STATE_F: begin // g permanently set to 0
                g <= 0;
                f <= 0;
            end
            default: begin
                state <= STATE_A;
                f <= 0;
                g <= 0;
            end
        endcase
    end
end

endmodule