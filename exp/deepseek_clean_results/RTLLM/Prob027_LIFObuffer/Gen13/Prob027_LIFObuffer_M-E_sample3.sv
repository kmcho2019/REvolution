module LIFObuffer (
    input wire [3:0] dataIn,
    input wire RW,
    input wire EN,
    input wire Rst,
    input wire Clk,
    output reg EMPTY,
    output reg FULL,
    output reg [3:0] dataOut
);

    // Circular stack memory (4 entries)
    reg [3:0] stack_mem [0:3];
    
    // Circular stack pointer (3 bits: 1 for direction, 2 for position)
    reg [2:0] circ_ptr;  // [2] = direction (0=up,1=down), [1:0] = position
    
    // Predictive data register
    reg [3:0] next_dataOut;
    
    // Internal control signals
    wire push_phase = ~Clk;  // Push on rising edge
    wire pop_phase = Clk;    // Pop on falling edge
    wire valid_op = EN && (push_phase ? ~RW : RW);
    
    // Circular pointer arithmetic
    wire [1:0] current_pos = circ_ptr[1:0];
    wire [1:0] next_pos_up = (current_pos == 2'b11) ? 2'b00 : current_pos + 1;
    wire [1:0] next_pos_down = (current_pos == 2'b00) ? 2'b11 : current_pos - 1;
    
    // Status detection
    wire pointer_wrapped = (circ_ptr[2] ^ (push_phase ? circ_ptr[1:0] == 2'b11 : circ_ptr[1:0] == 2'b00));
    
    always @(posedge Clk or negedge Clk or posedge Rst) begin
        if (Rst) begin
            // Initialize all registers and memory
            circ_ptr <= 3'b000;
            EMPTY <= 1'b1;
            FULL <= 1'b0;
            dataOut <= 4'b0;
            next_dataOut <= 4'b0;
            for (integer i = 0; i < 4; i = i + 1)
                stack_mem[i] <= 4'b0;
        end
        else if (valid_op) begin
            if (push_phase && !FULL) begin
                // Push operation on rising edge
                stack_mem[current_pos] <= dataIn;
                circ_ptr <= {~pointer_wrapped, next_pos_up};
                EMPTY <= 1'b0;
                FULL <= pointer_wrapped;
            end
            else if (pop_phase && !EMPTY) begin
                // Pop operation on falling edge
                dataOut <= next_dataOut;
                circ_ptr <= {~pointer_wrapped, next_pos_down};
                FULL <= 1'b0;
                EMPTY <= pointer_wrapped;
            end
        end
        
        // Always pre-fetch next output data
        if (!EMPTY) next_dataOut <= stack_mem[next_pos_down];
    end

    // Continuous flag updates
    always @(*) begin
        EMPTY = (circ_ptr[1:0] == 2'b00) && (circ_ptr[2] == 1'b0);
        FULL = (circ_ptr[1:0] == 2'b11) && (circ_ptr[2] == 1'b1);
    end

endmodule