module TopModule(
    input  clock,
    input  a,
    output p,
    output q
);

reg [1:0] state = 2'b00; // idle state
reg prev_a = 1'b0;

always @ (posedge clock or negedge clock) begin
    if (!clock) begin
        prev_a <= a;
    end else begin
        case (state)
            2'b00: begin // idle state
                if (a) begin
                    state <= 2'b01; // active state
                end else begin
                    state <= 2'b00;
                end
            end
            2'b01: begin // active state
                if (a) begin
                    state <= 2'b01;
                end else begin
                    state <= 2'b10; // waiting for a to go high again
                end
            end
            2'b10: begin // waiting for a to go high again
                if (a) begin
                    state <= 2'b01;
                end else begin
                    state <= 2'b10;
                end
            end
            default: state <= 2'b00;
        endcase
    end
end

always @ (*)
begin
    case (state)
        2'b00: begin
            p = 1'b0;
            q = 1'b0;
        end
        2'b01: begin
            p = a;
            q = 1'b0;
        end
        2'b10: begin
            p = 1'b0;
            q = 1'b1;
        end
        default: begin
            p = 1'b0;
            q = 1'b0;
        end
    endcase
end

endmodule