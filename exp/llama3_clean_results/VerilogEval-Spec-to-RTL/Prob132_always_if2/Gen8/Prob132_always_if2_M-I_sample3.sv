module TopModule (
    input      clk,
    input      cpu_overheated,
    output reg shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output reg keep_driving
);

    always @(posedge clk) begin
        shut_off_computer <= cpu_overheated;
        keep_driving <= !arrived && !gas_tank_empty;
    end

endmodule