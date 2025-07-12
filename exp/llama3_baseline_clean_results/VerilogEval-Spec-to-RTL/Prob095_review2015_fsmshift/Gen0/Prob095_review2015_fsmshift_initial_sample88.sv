module TopModule(
    input  clk,
    input  reset,
    output shift_ena
);

reg [1:0] state; // 0: idle, 1: shifting, 2: shifting_2, 3: shifting_3
reg [1:0] next_state;

always @(posedge clk) begin
    if (reset) begin
        state <= 1; // Start shifting when reset
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case(state)
        0: begin // idle
            shift_ena <= 0;
            if (reset) begin
                next_state <= 1;
            end else begin
                next_state <= 0;
            end
        end
        1: begin // shifting
            shift_ena <= 1;
            next_state <= 2;
        end
        2: begin // shifting_2
            shift_ena <= 1;
            next_state <= 3;
        end
        3: begin // shifting_3
            shift_ena <= 1;
            next_state <= 0;
        end
        default: begin
            shift_ena <= 0;
            next_state <= 0;
        end
    endcase
end

endmodule