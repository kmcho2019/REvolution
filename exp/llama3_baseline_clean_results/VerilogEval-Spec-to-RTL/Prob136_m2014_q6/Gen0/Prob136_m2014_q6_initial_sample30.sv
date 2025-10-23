module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

reg [3:0] current_state;
reg [3:0] next_state;

localparam A = 4'd0;
localparam B = 4'd1;
localparam C = 4'd2;
localparam D = 4'd3;
localparam E = 4'd4;
localparam F = 4'd5;

always @(*) begin
    case(current_state)
        A: begin
            if (w == 1'b1) begin
                next_state = A;
            end else begin
                next_state = B;
            end
        end
        B: begin
            if (w == 1'b1) begin
                next_state = D;
            end else begin
                next_state = C;
            end
        end
        C: begin
            if (w == 1'b1) begin
                next_state = D;
            end else begin
                next_state = E;
            end
        end
        D: begin
            if (w == 1'b1) begin
                next_state = A;
            end else begin
                next_state = F;
            end
        end
        E: begin
            if (w == 1'b1) begin
                next_state = D;
            end else begin
                next_state = E;
            end
        end
        F: begin
            if (w == 1'b1) begin
                next_state = D;
            end else begin
                next_state = C;
            end
        end
        default: next_state = A;
    endcase
end

always @(posedge clk or posedge reset) begin
    if (reset == 1'b1) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

always @(*) begin
    case(current_state)
        A: z = 1'b0;
        B: z = 1'b0;
        C: z = 1'b0;
        D: z = 1'b0;
        E: z = 1'b1;
        F: z = 1'b1;
        default: z = 1'b0;
    endcase
end

endmodule