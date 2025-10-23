module TopModule(
    input clk,
    input aresetn,
    input x,
    output z
);
    reg [1:0] state;
    reg [1:0] next_state;
    parameter IDLE = 2'b00;
    parameter SEEN_1 = 2'b01;
    parameter SEEN_10 = 2'b10;

    always_ff @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    always_comb begin
        case (state)
            IDLE: begin
                if (x == 1) begin
                    next_state = SEEN_1;
                end else begin
                    next_state = IDLE;
                end
            end
            SEEN_1: begin
                if (x == 1) begin
                    next_state = SEEN_10;
                end else begin
                    next_state = SEEN_1;
                end
            end
            SEEN_10: begin
                if (x == 1) begin
                    next_state = SEEN_10;
                end else begin
                    next_state = SEEN_1;
                end
            end
        endcase
    end

    always_comb begin
        if (state == SEEN_10 && x == 1) begin
            z = 1'b1;
        end else begin
            z = 1'b0;
        end
    end
endmodule