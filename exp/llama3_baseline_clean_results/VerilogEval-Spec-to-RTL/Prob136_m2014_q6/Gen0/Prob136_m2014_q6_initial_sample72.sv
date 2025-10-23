`define A 5'b00001
`define B 5'b00010
`define C 5'b00100
`define D 5'b01000
`define E 5'b10000
`define F 5'b00011

module TopModule(clk, reset, w, z);
    input clk;
    input reset;
    input w;
    output z;

    reg [4:0] current_state;
    reg [4:0] next_state;

    always @(posedge clk) begin
        if (reset) begin
            current_state <= `A;
        end else begin
            current_state <= next_state;
        end
    end

    always @(*) begin
        case (current_state)
            `A: begin
                if (~w) begin
                    next_state = `B;
                end else begin
                    next_state = `A;
                end
            end
            `B: begin
                if (~w) begin
                    next_state = `C;
                end else begin
                    next_state = `D;
                end
            end
            `C: begin
                if (~w) begin
                    next_state = `E;
                end else begin
                    next_state = `D;
                end
            end
            `D: begin
                if (~w) begin
                    next_state = `F;
                end else begin
                    next_state = `A;
                end
            end
            `E: begin
                if (~w) begin
                    next_state = `E;
                end else begin
                    next_state = `D;
                end
            end
            `F: begin
                if (~w) begin
                    next_state = `C;
                end else begin
                    next_state = `D;
                end
            end
            default: next_state = `A;
        endcase
    end

    assign z = (current_state == `E) || (current_state == `F);

endmodule