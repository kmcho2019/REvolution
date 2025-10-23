`timescale 1ns / 1ps

module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

reg [1:0] state_a;
reg [1:0] state_b;

// State transition logic
always @(posedge clk) begin
    if (reset) begin
        state_a <= 0;
        state_b <= 0;
    end else begin
        case (state_a)
            0: begin
                if (w) begin
                    state_a <= 0;
                end else begin
                    state_a <= 1;
                end
            end
            1: begin
                if (w) begin
                    state_a <= 3;
                end else begin
                    case (state_b)
                        0: state_a <= 2;
                        1: state_a <= 3;
                        2: state_a <= 3;
                        3: state_a <= 0;
                    endcase
                end
            end
            2: begin
                if (w) begin
                    state_a <= 3;
                end else begin
                    state_a <= 4;
                end
            end
            3: begin
                if (w) begin
                    state_a <= 0;
                end else begin
                    state_a <= 3;
                end
            end
            4: begin
                if (w) begin
                    state_a <= 3;
                end else begin
                    state_a <= 4;
                end
            end
        endcase
        
        case (state_b)
            0: begin
                if (state_a == 1 && w == 0) begin
                    state_b <= 0;
                end else if (state_a == 2 && w == 1) begin
                    state_b <= 1;
                end else if (state_a == 3 && w == 1) begin
                    state_b <= 2;
                end else begin
                    state_b <= 0;
                end
            end
            1: begin
                if (state_a == 1 && w == 1) begin
                    state_b <= 2;
                end else if (state_a == 2 && w == 0) begin
                    state_b <= 1;
                end else begin
                    state_b <= 1;
                end
            end
            2: begin
                if (state_a == 3 && w == 0) begin
                    state_b <= 2;
                end else if (state_a == 4 && w == 1) begin
                    state_b <= 1;
                end else begin
                    state_b <= 2;
                end
            end
            3: begin
                if (state_a == 0 && w == 1) begin
                    state_b <= 3;
                end else if (state_a == 2 && w == 1) begin
                    state_b <= 3;
                end else begin
                    state_b <= 3;
                end
            end
            4: begin
                if (state_a == 4 && w == 0) begin
                    state_b <= 4;
                end else begin
                    state_b <= 4;
                end
            end
        endcase
    end
end

// Output z logic
reg z_reg;
always @(posedge clk) begin
    if (reset) begin
        z_reg <= 0;
    end else begin
        if (state_a >= 2) begin
            z_reg <= 1;
        end else begin
            z_reg <= 0;
        end
    end
end

assign z = z_reg;

endmodule