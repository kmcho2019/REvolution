module TopModule(output wire one);
    // Parameter for constant high to aid synthesis tools clarity
    parameter logic HIGH = 1'b1;
    assign one = HIGH;
endmodule