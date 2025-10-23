module instr_reg (
    input clk,
    input rst,
    input [1:0] fetch,
    input [7:0] data,
    output wire [2:0] ins,
    output wire [4:0] ad1,
    output wire [7:0] ad2
);

    // Unified 16-bit register storing both instruction parts
    reg [15:0] instr_reg;
    
    // Control signals
    wire load_p1 = (fetch == 2'b01);
    wire load_p2 = (fetch == 2'b10);
    wire any_load = load_p1 | load_p2;
    
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            instr_reg <= 16'b0;
        end
        else if (any_load) begin
            // Circular shift implementation
            if (load_p1) begin
                // Load new p1, keep current p2
                instr_reg <= {data, instr_reg[7:0]};
            end
            else begin // load_p2
                // Load new p2, keep current p1
                instr_reg <= {instr_reg[15:8], data};
            end
        end
    end

    // Output assignments
    assign ins = instr_reg[15:13];  // Upper 3 bits of p1
    assign ad1 = instr_reg[12:8];   // Lower 5 bits of p1
    assign ad2 = instr_reg[7:0];    // Full p2 value

endmodule