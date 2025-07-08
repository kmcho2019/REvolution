module TopModule(
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output reg z
);

    reg [2:0] y_reg;
    reg [2:0] Y_next;

    // Next state logic and output z logic combinational block
    always @(*) begin
        case (y_reg)
            3'b000: begin
                if (x == 1'b0) begin
                    Y_next = 3'b000;
                    z = 1'b0;
                end else begin
                    Y_next = 3'b001;
                    z = 1'b0;
                end
            end
            3'b001: begin
                if (x == 1'b0) begin
                    Y_next = 3'b001;
                    z = 1'b0;
                end else begin
                    Y_next = 3'b100;
                    z = 1'b0;
                end
            end
            3'b010: begin
                if (x == 1'b0) begin
                    Y_next = 3'b010;
                    z = 1'b0;
                end else begin
                    Y_next = 3'b001;
                    z = 1'b0;
                end
            end
            3'b011: begin
                if (x == 1'b0) begin
                    Y_next = 3'b001;
                    z = 1'b1;
                end else begin
                    Y_next = 3'b010;
                    z = 1'b1;
                end
            end
            3'b100: begin
                if (x == 1'b0) begin
                    Y_next = 3'b011;
                    z = 1'b1;
                end else begin
                    Y_next = 3'b100;
                    z = 1'b1;
                end
            end
            default: begin
                Y_next = 3'b000;
                z = 1'b0;
            end
        endcase
    end

    // State update at rising edge of clk
    always @(posedge clk) begin
        y_reg <= y;
    end

    assign Y0 = Y_next[0];

endmodule