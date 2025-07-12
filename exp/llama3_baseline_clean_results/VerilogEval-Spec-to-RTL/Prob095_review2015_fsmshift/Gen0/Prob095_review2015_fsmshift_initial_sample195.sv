module TopModule (
    input clk,
    input reset,
    output shift_ena
);

reg [1:0] state; // 0: idle, 1: shifting, 2: shifting_1, 3: shifting_2
reg [1:0] next_state;

always @(*) begin
    case(state)
        0: begin
            if(reset) begin
                next_state = 1;
                shift_ena = 1;
            end else begin
                next_state = 0;
                shift_ena = 0;
            end
        end
        1: begin
            next_state = 2;
            shift_ena = 1;
        end
        2: begin
            next_state = 3;
            shift_ena = 1;
        end
        3: begin
            next_state = 0;
            shift_ena = 1;
        end
        default: begin
            next_state = 0;
            shift_ena = 0;
        end
    endcase
end

always @(posedge clk) begin
    if(reset) begin
        state <= 1;
    end else begin
        state <= next_state;
    end
end

endmodule