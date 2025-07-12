module TopModule(
    input clk,
    input aresetn,
    input x,
    output z
);

enum logic [1:0] { Idle, GotOne, GotZero } state, next_state;

always_ff @(posedge clk or negedge aresetn) begin
    if (~aresetn) begin
        state <= Idle;
    end else begin
        state <= next_state;
    end
end

always_comb begin
    case (state)
        Idle: begin
            if (x) begin
                next_state = GotOne;
            end else begin
                next_state = Idle;
            end
            z = 1'b0;
        end
        GotOne: begin
            if (~x) begin
                next_state = GotZero;
            end else begin
                next_state = GotOne;
            end
            z = 1'b0;
        end
        GotZero: begin
            if (x) begin
                next_state = GotOne;
                z = 1'b1;
            end else begin
                next_state = GotZero;
            end
        end
        default: begin
            next_state = Idle;
            z = 1'b0;
        end
    endcase
end

endmodule