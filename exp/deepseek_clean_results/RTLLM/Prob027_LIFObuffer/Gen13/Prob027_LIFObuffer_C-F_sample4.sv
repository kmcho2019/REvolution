module LIFObuffer (
    input wire [3:0] dataIn,
    input wire RW,
    input wire EN,
    input wire Rst,
    input wire Clk,
    output wire EMPTY,
    output wire FULL,
    output reg [3:0] dataOut
);

    // Packed array for stack memory (more area efficient)
    reg [3:0] stack_mem [0:3];
    
    // Gray-coded stack pointer (2 bits) for better timing
    reg [1:0] SP, SP_next;
    reg empty_state, empty_state_next;
    
    // Operation control signals
    wire do_push = EN && !RW && !FULL;
    wire do_pop  = EN && RW && !EMPTY;
    
    // Efficient combinational flag generation
    assign EMPTY = empty_state;
    assign FULL  = (!empty_state && (SP == 2'b11));
    
    // Gray code increment/decrement functions
    function [1:0] gray_inc;
        input [1:0] gray;
        begin
            case(gray)
                2'b00: gray_inc = 2'b01;
                2'b01: gray_inc = 2'b11;
                2'b11: gray_inc = 2'b10;
                2'b10: gray_inc = 2'b00;
            endcase
        end
    endfunction
    
    function [1:0] gray_dec;
        input [1:0] gray;
        begin
            case(gray)
                2'b00: gray_dec = 2'b10;
                2'b01: gray_dec = 2'b00;
                2'b11: gray_dec = 2'b01;
                2'b10: gray_dec = 2'b11;
            endcase
        end
    endfunction
    
    // Next state logic
    always @(*) begin
        // Default: hold current state
        SP_next = SP;
        empty_state_next = empty_state;
        
        if (Rst) begin
            SP_next = 2'b00;
            empty_state_next = 1'b1;
        end
        else if (do_push) begin
            if (empty_state) begin
                empty_state_next = 1'b0;
            end
            else begin
                SP_next = gray_inc(SP);
            end
        end
        else if (do_pop) begin
            if (SP == 2'b00) begin
                empty_state_next = 1'b1;
            end
            else begin
                SP_next = gray_dec(SP);
            end
        end
    end
    
    // Sequential logic
    always @(posedge Clk) begin
        // Update state
        SP <= SP_next;
        empty_state <= empty_state_next;
        
        // Stack operations
        if (do_push) begin
            if (empty_state) begin
                stack_mem[0] <= dataIn;
            end
            else begin
                stack_mem[SP_next] <= dataIn;
            end
        end
        else if (do_pop) begin
            dataOut <= stack_mem[SP];
        end
        
        // Optimized reset condition
        if (Rst) begin
            dataOut <= 4'b0;
            stack_mem[0] <= 4'b0; // Only clear first location
        end
    end

endmodule