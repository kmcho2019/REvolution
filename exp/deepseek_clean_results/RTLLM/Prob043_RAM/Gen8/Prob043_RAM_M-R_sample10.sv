module RAM (
    input clk,
    input rst_n,
    input write_en,
    input [2:0] write_addr,
    input [5:0] write_data,
    input read_en,
    input [2:0] read_addr,
    output [5:0] read_data
);

    parameter WIDTH = 6;
    parameter DEPTH = 8;
    
    // Memory as discrete registers
    reg [WIDTH-1:0] mem0, mem1, mem2, mem3, 
                    mem4, mem5, mem6, mem7;

    // Write operation with clock gating
    wire clk_gated = clk & write_en;
    always @(posedge clk_gated or negedge rst_n) begin
        if (!rst_n) begin
            mem0 <= 0; mem1 <= 0; mem2 <= 0; mem3 <= 0;
            mem4 <= 0; mem5 <= 0; mem6 <= 0; mem7 <= 0;
        end else begin
            case (write_addr)
                3'b000: mem0 <= write_data;
                3'b001: mem1 <= write_data;
                3'b010: mem2 <= write_data;
                3'b011: mem3 <= write_data;
                3'b100: mem4 <= write_data;
                3'b101: mem5 <= write_data;
                3'b110: mem6 <= write_data;
                3'b111: mem7 <= write_data;
            endcase
        end
    end

    // Combinational read with explicit mux
    wire [5:0] raw_read_data;
    assign raw_read_data = 
        (read_addr == 3'b000) ? mem0 :
        (read_addr == 3'b001) ? mem1 :
        (read_addr == 3'b010) ? mem2 :
        (read_addr == 3'b011) ? mem3 :
        (read_addr == 3'b100) ? mem4 :
        (read_addr == 3'b101) ? mem5 :
        (read_addr == 3'b110) ? mem6 :
        mem7;
    
    // Output with enable gate
    assign read_data = read_en ? raw_read_data : 6'b0;

endmodule