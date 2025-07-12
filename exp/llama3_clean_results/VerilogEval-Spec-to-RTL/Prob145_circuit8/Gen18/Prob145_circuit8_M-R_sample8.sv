module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

reg [1:0] current_state;

always @(posedge clock or negedge clock) begin
    case (current_state)
        2'b00: begin // State0
            if (clock == 1) begin
                if (a == 1) begin
                    current_state <= 2'b01; // Transition to State1
                    p <= a;
                    q <= 0;
                end else begin
                    current_state <= 2'b00;
                    p <= 0;
                    q <= 0;
                end
            end else if (a == 1) begin // Negedge clock, a=1
                current_state <= 2'b00;
                p <= 0;
                q <= 0;
            end
        end
        2'b01: begin // State1
            if (clock == 1) begin
                if (a == 1) begin
                    current_state <= 2'b01;
                    p <= a;
                    q <= 1;
                end else begin
                    current_state <= 2'b01;
                    p <= 0;
                    q <= 1;
                end
            end else if (a == 0) begin // Negedge clock, a=0
                current_state <= 2'b00;
                q <= 0;
            end
        end
        default: begin
            current_state <= 2'b00;
            p <= 0;
            q <= 0;
        end
    endcase
end

initial begin
    current_state = 2'b00;
    p = 0;
    q = 0;
end

endmodule