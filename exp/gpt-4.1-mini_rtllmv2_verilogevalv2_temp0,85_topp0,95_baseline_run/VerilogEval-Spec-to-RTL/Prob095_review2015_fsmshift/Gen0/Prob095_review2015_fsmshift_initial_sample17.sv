module TopModule (
    input  clk,
    input  reset,
    output reg shift_ena
);

    typedef enum logic [0:0] {INACTIVE=1'b0, ACTIVE=1'b1} state_t;
    state_t state;
    reg [1:0] count;

    always @(posedge clk) begin
        if (reset) begin
            state <= ACTIVE;
            count <= 2'd0;
            shift_ena <= 1'b1;
        end else begin
            case (state)
                ACTIVE: begin
                    if (count == 2'd3) begin
                        state <= INACTIVE;
                        shift_ena <= 1'b0;
                    end else begin
                        count <= count + 1;
                        shift_ena <= 1'b1;
                    end
                end
                INACTIVE: begin
                    shift_ena <= 1'b0;
                end
            endcase
        end
    end

endmodule