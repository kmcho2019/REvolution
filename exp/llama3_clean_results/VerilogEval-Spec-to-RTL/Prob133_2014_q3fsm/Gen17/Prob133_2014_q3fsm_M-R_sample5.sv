module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

typedef enum logic [0:0] {A, B} state_t;
state_t state;

reg [2:0] shift_reg;
reg [1:0] count;

always @(posedge clk) begin
    if(reset) begin
        state <= A;
        shift_reg <= 3'b000;
        count <= 2'b00;
        z <= 1'b0;
    end else begin
        case(state)
            A: begin
                if(s) begin
                    state <= B;
                    shift_reg <= 3'b000;
                    count <= 2'b00;
                end
            end
            B: begin
                shift_reg <= {w, shift_reg[2:1]};
                count <= (w ? (count + 1'b1) : count);
                if(count == 2'b10) begin
                    z <= 1'b1;
                end else begin
                    z <= 1'b0;
                end
                if(w == 1'b1 && count == 2'b11) begin
                    count <= 2'b01;
                end else if(w == 1'b0 && count == 2'b00) begin
                    count <= 2'b00;
                end
            end
            default: ;
        endcase
    end
end

endmodule