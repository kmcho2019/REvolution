module TopModule (
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output reg z
);

    reg [2:0] Y;
    reg z_next;

    // Combined next state and output logic using case statement
    always @(*) begin
        case (y)
            3'b000: begin
                Y = x ? 3'b001 : 3'b000;
                z_next = 1'b0;
            end
            3'b001: begin
                Y = x ? 3'b100 : 3'b001;
                z_next = 1'b0;
            end
            3'b010: begin
                Y = x ? 3'b001 : 3'b010;
                z_next = 1'b0;
            end
            3'b011: begin
                Y = x ? 3'b010 : 3'b001;
                z_next = 1'b1;
            end
            3'b100: begin
                Y = x ? 3'b100 : 3'b011;
                z_next = 1'b1;
            end
            default: begin
                Y = 3'b000;
                z_next = 1'b0;
            end
        endcase
    end

    // Register the output to reduce glitches
    always @(posedge clk) begin
        z <= z_next;
    end

    assign Y0 = Y[0];

endmodule