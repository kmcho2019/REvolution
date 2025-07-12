module TopModule (
    input      clk,
    input      cpu_overheated,
    output reg shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output reg keep_driving
);

    reg cpu_overheated_prev;
    reg arrived_debounced;
    reg [1:0] arrived_filter;
    reg tank_empty_memory;

    always @(posedge clk) begin
        // Edge detection for overheating
        cpu_overheated_prev <= cpu_overheated;
        
        // Simple debounce for arrived signal (2-cycle)
        arrived_filter <= {arrived_filter[0], arrived};
        if (arrived_filter == 2'b11)
            arrived_debounced <= 1'b1;
        else if (arrived_filter == 2'b00)
            arrived_debounced <= 1'b0;
        
        // Remember empty tank condition until arrival
        if (arrived_debounced)
            tank_empty_memory <= 1'b0;
        else if (gas_tank_empty)
            tank_empty_memory <= 1'b1;
    end

    always @(*) begin
        // Shut down on rising edge of overheating
        shut_off_computer = (~cpu_overheated_prev & cpu_overheated);
        
        // Conservative driving policy
        keep_driving = ~arrived_debounced & ~tank_empty_memory;
    end

endmodule